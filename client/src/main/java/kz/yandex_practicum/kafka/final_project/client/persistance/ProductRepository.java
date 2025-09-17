package kz.yandex_practicum.kafka.final_project.client.persistance;

import org.springframework.data.elasticsearch.annotations.Query;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductRepository extends ElasticsearchRepository<Product, String> {

    @Query("""
            {
              "match_phrase": { "name": { "query": "?0" } }
            }
            """)
    List<Product> findByNameContaining(String name);
}