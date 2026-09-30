package com.nebula.gateway.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/gateway")
public class GatewayController {

    private static final Logger log =
            LoggerFactory.getLogger(GatewayController.class);

    @GetMapping("/testApi")
    public String testGateway() {
        log.info("Api-gateway started!!");
        return "I am API-Gateway";
    }

    @GetMapping("/testApiPub")
    public String testGatewayPub() {
        return "I am public URL of Gateway!!";
    }

}
