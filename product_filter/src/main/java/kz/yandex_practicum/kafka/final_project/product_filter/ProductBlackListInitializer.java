package kz.yandex_practicum.kafka.final_project.product_filter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

/// Инициализатор для публикации сообщений о добавлении продуктов в черный список при запуске приложения.
///
/// @author a.melis
@Component
public class ProductBlackListInitializer {
    private static final Logger LOGGER = LoggerFactory.getLogger(ProductBlackListInitializer.class);

    private final ProductBlackListPublisher productBlackListPublisher;
    private final String file;

    public ProductBlackListInitializer(ProductBlackListPublisher productBlackListPublisher,
                                       @Value("${application.data.product.black_list_file_path}") String file) {
        this.productBlackListPublisher = productBlackListPublisher;
        this.file = file;
    }

    /// Инициализация и публикация сообщений о добавлении продуктов в черный список из файла при запуске приложения.
    @EventListener(ApplicationReadyEvent.class)
    public void init() {
        Path filePath = Path.of(file);

        try (var lines = Files.lines(filePath)) {
            lines.forEach(productID -> productBlackListPublisher.publish(productID.trim(), "initial load"));
        } catch (IOException e) {
            LOGGER.error("Failed to read black list file: file = '{}'", file, e);
            throw new RuntimeException(e);
        }
    }
}