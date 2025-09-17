package kz.yandex_practicum.kafka.final_project.client.persistance;

import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

import java.math.BigDecimal;

public class Price {
    @Field(type = FieldType.Scaled_Float, scalingFactor = 100)
    private BigDecimal amount;

    @Field(type = FieldType.Keyword)
    private String currency;

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }
}