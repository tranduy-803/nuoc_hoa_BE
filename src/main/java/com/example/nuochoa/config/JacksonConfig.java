package com.example.nuochoa.config;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

@Configuration
public class JacksonConfig {

    @Bean
    @Primary
    public ObjectMapper objectMapper() {
        ObjectMapper mapper = new ObjectMapper();
        JavaTimeModule javaTimeModule = new JavaTimeModule();
        
        // Custom serializer cho LocalDateTime với timezone Việt Nam
        javaTimeModule.addSerializer(LocalDateTime.class, new LocalDateTimeSerializer());
        
        mapper.registerModule(javaTimeModule);
        mapper.disable(com.fasterxml.jackson.databind.SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        
        return mapper;
    }

    public static class LocalDateTimeSerializer extends JsonSerializer<LocalDateTime> {
        private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");
        
        @Override
        public void serialize(LocalDateTime value, JsonGenerator gen, SerializerProvider serializers) throws IOException {
            if (value != null) {
                // Convert về timezone Việt Nam
                String formatted = value.atZone(ZoneId.of("Asia/Ho_Chi_Minh"))
                    .format(FORMATTER);
                gen.writeString(formatted);
            } else {
                gen.writeNull();
            }
        }
    }
}
