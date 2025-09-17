package kz.yandex_practicum.kafka.final_project.client;

import kz.yandex_practicum.kafka.final_project.contract.shop.v1.Product;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

@Component
public class ProductSearchResultPublisher {
    private static final Logger LOGGER = LoggerFactory.getLogger(ProductSearchResultPublisher.class);

    private final String topic;
    private final KafkaTemplate<String, Product> kafkaTemplate;

    public ProductSearchResultPublisher(@Value("${application.messaging.product_search_result.topic}") String topic,
                                        KafkaTemplate<String, Product> kafkaTemplate) {
        this.topic = topic;
        this.kafkaTemplate = kafkaTemplate;
    }

    public void publish(String userID, Product product) {
        kafkaTemplate
                .send(topic, userID, product)
                .whenComplete((res, ex) -> {
                    if (ex == null) {
                        LOGGER.info("ok topic = {} part = {} off = {} ts = {}",
                                res.getRecordMetadata().topic(),
                                res.getRecordMetadata().partition(),
                                res.getRecordMetadata().offset(),
                                res.getRecordMetadata().timestamp());
                    } else {
                        if (ex instanceof org.apache.kafka.common.errors.SerializationException) {
                            LOGGER.error("Serialization error: userID = {}, topic = {}, reason = {}",
                                    userID, topic, ex.getMessage(), ex);
                        } else {
                            LOGGER.error("Unexpected error: userID = {}, topic = {}, reason = {}",
                                    userID, topic, ex.getMessage(), ex);
                        }
                    }
                });
    }
}