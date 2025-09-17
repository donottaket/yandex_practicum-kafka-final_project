package kz.yandex_practicum.kafka.final_project.shop;

import com.fasterxml.jackson.databind.ObjectMapper;
import kz.yandex_practicum.kafka.final_project.contract.shop.v1.Product;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Stream;

/// Job для публикации продуктов.
/// Публикует по одному файлу за тик. Останавливается, когда файл отсутствует.
///
/// @author a.melis
@Component
public class ProductPublishInitializerJob {
    private static final Logger LOGGER = LoggerFactory.getLogger(ProductPublishInitializerJob.class);

    private int fileCounter = 1;

    private final ProductPublisher productPublisher;
    private final ObjectMapper objectMapper;
    private final String directory;

    public ProductPublishInitializerJob(ProductPublisher productPublisher,
                                        ObjectMapper objectMapper,
                                        @Value("${application.data.product.directory_path}") String directory) {
        this.productPublisher = productPublisher;
        this.objectMapper = objectMapper;
        this.directory = directory;
    }

    /// Публикует продукты из файлов в Kafka с фиксированным интервалом.
    @Scheduled(fixedDelayString = "${application.data.product.publish_interval_ms}")
    public void publish() {
        try (Stream<Path> files = Files.list(Paths.get(directory))) {
            if (fileCounter >= files.count()) {
                LOGGER.info("All products have been published");
                return;
            }
        } catch (IOException e) {
            LOGGER.error("Failed to list files in directory: directory = '{}'", directory, e);
            throw new RuntimeException(e);
        }

        productPublisher.publish(readProductFromFile());

        ++fileCounter;
    }

    private Product readProductFromFile() {
        Path filePath = Path.of(directory, "product_" + String.format("%06d", fileCounter) + ".json");

        try (InputStream is = Files.newInputStream(filePath, java.nio.file.StandardOpenOption.READ)) {
            return objectMapper.readValue(is, Product.class);
        } catch (IOException e) {
            LOGGER.error("Failed to read product from file: filePath = '{}'", filePath, e);
            throw new RuntimeException(e);
        }
    }
}