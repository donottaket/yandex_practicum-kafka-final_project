package kz.yandex_practicum.kafka.final_project.product_filter;

import org.springframework.web.bind.annotation.*;

/// Контроллер для управления черным списком товаров.
///
/// @author a.melis
@RestController
@RequestMapping("/black-list")
public class BlackListController {
    private final BlackListAdmin blackListAdmin;

    public BlackListController(BlackListAdmin blackListAdmin) {
        this.blackListAdmin = blackListAdmin;
    }

    /// Добавляет товар в черный список с указанием причины.
    ///
    /// @param productID ID товара
    /// @param reason    причина блокировки
    /// @return Сообщение о результате операции
    @PostMapping("/{productID}/block")
    public String block(@PathVariable("productID") String productID, @RequestBody BlockReason reason) {
        blackListAdmin.block(productID, reason.text());
        return "Товар внесен в черный список: productID = " + productID + ", reason = " + reason.text();
    }

    /// Удаляет товар из черного списка.
    ///
    /// @param productID ID товара
    /// @return Сообщение о результате операции
    @PostMapping("/{productID}/unblock")
    public String unblock(@PathVariable("productID") String productID) {
        blackListAdmin.unblock(productID);
        return "Товар удален из черного списка: productID = " + productID;
    }
}