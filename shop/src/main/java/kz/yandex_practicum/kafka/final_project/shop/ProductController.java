package kz.yandex_practicum.kafka.final_project.shop;

import kz.yandex_practicum.kafka.final_project.contract.shop.v1.Product;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/// Контроллер для работы с товаром.
///
/// @author a.melis
@RestController
@RequestMapping("/products")
public class ProductController {
    private final ProductPublisher productPublisher;

    public ProductController(ProductPublisher productPublisher) {
        this.productPublisher = productPublisher;
    }

    @PostMapping
    public void create(@RequestBody Product product) {
        productPublisher.publish(product);
    }
}