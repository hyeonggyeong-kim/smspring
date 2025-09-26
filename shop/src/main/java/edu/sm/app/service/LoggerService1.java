package edu.sm.app.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Random;

@Service
@Slf4j
public class LoggerService1 {
    public void save1(String data){
        log.info(data);
    }
}
