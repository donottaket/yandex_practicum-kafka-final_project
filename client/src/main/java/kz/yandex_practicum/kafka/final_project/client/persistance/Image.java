package kz.yandex_practicum.kafka.final_project.client.persistance;

import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

public class Image {
    @Field(type = FieldType.Keyword)
    private String url;

    @Field(type = FieldType.Text)
    private String alt;

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getAlt() {
        return alt;
    }

    public void setAlt(String alt) {
        this.alt = alt;
    }
}