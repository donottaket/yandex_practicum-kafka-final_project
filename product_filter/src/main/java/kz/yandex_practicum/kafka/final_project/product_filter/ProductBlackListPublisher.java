package kz.yandex_practicum.kafka.final_project.product_filter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

/// Сервис для публикации сообщений о добавлении продуктов в черный список в Kafka.
///
/// @author a.melis
@Component
public class ProductBlackListPublisher {
    private static final Logger LOGGER = LoggerFactory.getLogger(ProductBlackListPublisher.class);

    private final String topic;
    private final KafkaTemplate<String, String> kafkaTemplate;

    public ProductBlackListPublisher(@Value("${application.messaging.black_list.topic}") String topic,
                                     KafkaTemplate<String, String> kafkaTemplate) {
        this.topic = topic;
        this.kafkaTemplate = kafkaTemplate;
    }

    /// Публикует идентификатор продукта в Kafka.
    ///
    /// @param productID Идентификатор продукта для публикации.
    /// @param reason    причина добавления в черный список.
    public void publish(String productID, String reason) {
        kafkaTemplate
                .send(topic, productID, reason)
                .whenComplete((res, ex) -> {
                    if (ex == null) {
                        LOGGER.info("ok topic = {} part = {} off = {} ts = {}",
                                res.getRecordMetadata().topic(),
                                res.getRecordMetadata().partition(),
                                res.getRecordMetadata().offset(),
                                res.getRecordMetadata().timestamp());
                    } else {
                        if (ex instanceof org.apache.kafka.common.errors.SerializationException) {
                            LOGGER.error("Serialization error: productID = {}, topic = {}, reason = {}",
                                    productID, topic, ex.getMessage(), ex);
                        } else {
                            LOGGER.error("Unexpected error: productID = {}, topic = {}, reason = {}",
                                    productID, topic, ex.getMessage(), ex);
                        }
                    }
                });
    }
}