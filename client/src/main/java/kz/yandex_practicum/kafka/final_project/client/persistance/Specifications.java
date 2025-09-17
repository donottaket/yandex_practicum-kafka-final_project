package kz.yandex_practicum.kafka.final_project.client.persistance;

import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

public class Specifications {
    @Field(type = FieldType.Keyword)
    private String weight;

    @Field(type = FieldType.Keyword)
    private String waterResistance;

    @Field(type = FieldType.Keyword)
    private String dimensions;

    @Field(type = FieldType.Keyword)
    private String batteryLife;

    public String getWeight() {
        return weight;
    }

    public void setWeight(String weight) {
        this.weight = weight;
    }

    public String getWaterResistance() {
        return waterResistance;
    }

    public void setWaterResistance(String waterResistance) {
        this.waterResistance = waterResistance;
    }

    public String getDimensions() {
        return dimensions;
    }

    public void setDimensions(String dimensions) {
        this.dimensions = dimensions;
    }

    public String getBatteryLife() {
        return batteryLife;
    }

    public void setBatteryLife(String batteryLife) {
        this.batteryLife = batteryLife;
    }
}