package com.example.demo;

import java.time.Instant;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @GetMapping("/")
    public Map<String, String> home() {
        return Map.of(
                "message", "Hello Ayoub, GitOps upadted to v10",
                "version", "v10",
                "time", Instant.now().toString()
        );
    }

    @GetMapping("/hello")
    public String hello() {
        return "Hello GitOps from Spring Boot v10";
    }
}
