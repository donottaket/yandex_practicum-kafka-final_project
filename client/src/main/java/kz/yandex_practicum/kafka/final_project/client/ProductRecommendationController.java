package kz.yandex_practicum.kafka.final_project.client;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

/// Контроллер для получения рекомендаций.
///
/// @author a.melis
@RestController
@RequestMapping("/product-recommendations")
public class ProductRecommendationController {
    private static final String KSQL = "SELECT * FROM recommendation WHERE user_id = '";

    private final RestTemplate restTemplate;
    private final String url;

    public ProductRecommendationController(RestTemplate restTemplate, @Value("${application.ksql_db.url}") String url) {
        this.restTemplate = restTemplate;
        this.url = url;
    }

    /// Получает рекомендации для пользователя по его ID.
    ///
    /// @param userID ID пользователя для получения рекомендаций.
    /// @return Сообщение с рекомендациями для пользователя.
    @GetMapping("/{user-id}")
    public String getRecommendations(@PathVariable("user-id") String userID) {
        return restTemplate
                .postForEntity(url + "/query", new RecommendationQuery(KSQL + userID + "';"), String.class)
                .getBody();
    }

    static class RecommendationQuery {
        private String ksql;

        public RecommendationQuery(String ksql) {
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