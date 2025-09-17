package kz.yandex_practicum.kafka.final_project.client;

import kz.yandex_practicum.kafka.final_project.client.persistance.Product;
import kz.yandex_practicum.kafka.final_project.client.persistance.ProductRepository;
import kz.yandex_practicum.kafka.final_project.contract.shop.v1.Image;
import kz.yandex_practicum.kafka.final_project.contract.shop.v1.Price;
import kz.yandex_practicum.kafka.final_project.contract.shop.v1.Stock;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/// Контроллер для управления товарами.
///
/// @author a.melis
@RestController
@RequestMapping("/products")
public class ProductController {
    private final ProductRepository productRepository;
    private final ProductSearchResultPublisher productSearchResultPublisher;

    public ProductController(ProductRepository productRepository,
                             ProductSearchResultPublisher productSearchResultPublisher) {
        this.productRepository = productRepository;
        this.productSearchResultPublisher = productSearchResultPublisher;
    }

    /// Ищет товары по части названия.
    ///
    /// @param name часть названия товара для поиска.
    /// @return список товаров, содержащих указанную часть в названии.
    @GetMapping("/search")
    public List<Product> searchByName(@RequestParam("name") String name, @RequestParam("user-id") String userID) {
        List<Product> productList = productRepository.findByNameContaining(name);

        productList.forEach(product -> {
            kz.yandex_practicum.kafka.final_project.contract.shop.v1.Product kafkaProduct =
                    new kz.yandex_practicum.kafka.final_project.contract.shop.v1.Product();
            Price price = new Price();
            price.setAmount(product.getPrice().getAmount().doubleValue());
            price.setCurrency(product.getPrice().getCurrency());

            Stock stock = new Stock();
            stock.setAvailable(product.getStock().getAvailable());
            stock.setReserved(product.getStock().getReserved());

            List<Image> images = product
                    .getImages()
                    .stream()
                    .map(i -> new Image(i.getUrl(), i.getAlt()))
                    .toList();

            Map<String, String> specifications = new HashMap<>();
            specifications.put("batteryLife", product.getSpecifications().getBatteryLife());
            specifications.put("dimensions", product.getSpecifications().getDimensions());
            specifications.put("waterResistance", product.getSpecifications().getWaterResistance());
            specifications.put("weight", product.getSpecifications().getWeight());

            kafkaProduct.setProductId(product.getProductId());
            kafkaProduct.setStoreId(product.getStoreId());
            kafkaProduct.setName(product.getName());
            kafkaProduct.setDescription(product.getDescription());
            kafkaProduct.setCategory(product.getCategory());
            kafkaProduct.setBrand(product.getBrand());
            kafkaProduct.setSku(product.getSku());
            kafkaProduct.setTags(product.getTags());
            kafkaProduct.setCreatedAt(product.getCreatedAt());
            kafkaProduct.setUpdatedAt(product.getUpdatedAt());
            kafkaProduct.setIndex(product.getIndex());
            kafkaProduct.setPrice(price);
            kafkaProduct.setStock(stock);
            kafkaProduct.setImages(images);
            kafkaProduct.setSpecifications(specifications);

            productSearchResultPublisher.publish(userID, kafkaProduct);
        });

        return productList;
    }
}