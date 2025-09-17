package kz.yandex_practicum.kafka.final_project.client.persistance;

import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

public class Stock {
    @Field(type = FieldType.Integer)
    private Integer available;

    @Field(type = FieldType.Integer)
    private Integer reserved;

    public Integer getAvailable() {
        return available;
    }

    public void setAvailable(Integer available) {
        this.available = available;
    }

    public Integer getReserved() {
        return reserved;
    }

    public void setReserved(Integer reserved) {
        this.reserved = reserved;
    }
}