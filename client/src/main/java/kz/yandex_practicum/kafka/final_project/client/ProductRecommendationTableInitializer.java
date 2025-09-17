package kz.yandex_practicum.kafka.final_project.client;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component
public class ProductRecommendationTableInitializer {
    private static final String KSQL = """
            CREATE SOURCE TABLE recommendation (
                user_id VARCHAR PRIMARY KEY
            ) WITH (
                KAFKA_TOPIC = 'client.search.result',
                VALUE_FORMAT = 'AVRO',
                VALUE_SCHEMA_ID = 1
            );
            """;

    private final RestTemplate restTemplate;
    private final String url;

    public ProductRecommendationTableInitializer(RestTemplate restTemplate,
                                                 @Value("${application.ksql_db.url}") String url) {
        this.restTemplate = restTemplate;
        this.url = url;
    }

    @EventListener(ApplicationReadyEvent.class)
    public void init() {
        restTemplate.postForEntity(url + "/ksql", new TableCreateRequest(KSQL), Void.class);
    }

    static class TableCreateRequest {
        private String ksql;

        public TableCreateRequest(String ksql) {
            this.ksql = ksql;
        }

        public String getKsql() {
            return ksql;
        }

        public void setKsql(String ksql) {
            this.ksql = ksql;
        }
    }
}