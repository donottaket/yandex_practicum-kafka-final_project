package kz.yandex_practicum.kafka.final_project.product_filter;

import org.springframework.stereotype.Service;

/// Сервис для управления черным списком продуктов, позволяющий блокировать и разблокировать продукты.
///
/// @author a.melis
@Service
public class BlackListAdmin {
    private final ProductBlackListPublisher productBlackListPublisher;

    public BlackListAdmin(ProductBlackListPublisher productBlackListPublisher) {
        this.productBlackListPublisher = productBlackListPublisher;
    }

    /// Блокирует продукт, отправляя сообщение в Kafka с указанием причины блокировки.
    ///
    /// @param productID ID продукта
    /// @param reason    причина блокировки, может быть null или пустой строкой
    public void block(String productID, String reason) {
        productBlackListPublisher.publish(productID, (reason == null || reason.isBlank()) ? "no reason" : reason);
    }

    /// Разблокирует продукт, отправляя сообщение в Kafka с null значением.
    ///
    /// @param productID ID продукта
    public void unblock(String productID) {
        productBlackListPublisher.publish(productID, null);
    }
}