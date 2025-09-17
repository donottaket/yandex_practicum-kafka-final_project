package kz.yandex_practicum.kafka.final_project.product_filter;

import kz.yandex_practicum.kafka.final_project.contract.shop.v1.Product;
import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.streams.StreamsBuilder;
import org.apache.kafka.streams.kstream.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.annotation.EnableKafkaStreams;

/// Процессор для фильтрации продуктов на основе черного списка.
///
/// @author a.melis
@Configuration
@EnableKafkaStreams
public class ProductFilterProcessor {

    @Bean
    KStream<String, Product> process(StreamsBuilder streamsBuilder,
                                     @Value("${application.messaging.product.topic}") String in,
                                     @Value("${application.messaging.black_list.topic}") String bl,
                                     @Value("${application.messaging.filtered_product.topic}") String out) {
        KStream<String, Product> products = streamsBuilder.stream(in);

        KTable<String, String> blackListTable = streamsBuilder
                .table(
                        bl,
                        Consumed.with(Serdes.String(), Serdes.String()),
                        Materialized.as("black-list-store")
                );

        blackListTable.toStream().peek((key, value) -> {
            // Логируем добавление в черный список
            System.out.println("Product ID added to black list: " + key + ", reason: " + value);
        });


        KStream<String, Product> filtered = products
                .leftJoin(blackListTable,
                        (product, blVal) -> blVal == null ? product : null,
                        Joined.with(Serdes.String(), null, Serdes.String()))
                .filter((key, product) -> product != null);

        filtered.to(out);

        return filtered;
    }
}