package kz.yandex_practicum.kafka.final_project.shop;

import kz.yandex_practicum.kafka.final_project.contract.shop.v1.Product;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

/// Сервис для публикации сообщений о продуктах в Kafka.
///
/// @author a.melis
@Service
public class ProductPublisher {
    private static final Logger LOGGER = LoggerFactory.getLogger(ProductPublisher.class);

    private final String topic;
    private final KafkaTemplate<String, Product> kafkaTemplate;

    public ProductPublisher(@Value("${application.messaging.product.topic}") String topic,
                            KafkaTemplate<String, Product> kafkaTemplate) {
        this.topic = topic;
        this.kafkaTemplate = kafkaTemplate;
    }

    /// Публикует информацию о продукте в Kafka.
    ///
    /// @param product Продукт для публикации.
    public void publish(Product product) {
        kafkaTemplate
                .send(topic, product.getProductId(), product)
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
                                    product.getProductId(), topic, ex.getMessage(), ex);
                        } else {
                            LOGGER.error("Unexpected error: productID = {}, topic = {}, reason = {}",
                                    product.getProductId(), topic, ex.getMessage(), ex);
                        }
                    }
                });
    }
}