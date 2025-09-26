package edu.sm.controller;

import edu.sm.app.dto.Content;
import edu.sm.app.dto.Marker;
import edu.sm.app.dto.Search;
import edu.sm.app.service.*;
import edu.sm.util.FileUploadUtil;
import edu.sm.util.WeatherUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequiredArgsConstructor
@Slf4j
public class MainRestController {
    @Value("${app.key.wkey}")
    String wkey;
    private final LoggerService1 loggerService1;
    private final LoggerService2 loggerService2;
    private final LoggerService3 loggerService3;
    private final LoggerService4 loggerService4;

    private String data;

    @RequestMapping("/getwt1")
    public Object getwt1(@RequestParam("loc") String loc) throws IOException, ParseException, org.json.simple.parser.ParseException {
        return WeatherUtil.getWeather(loc, wkey);
    }
    @RequestMapping("/getwt2")
    public Object getwt2(@RequestParam("loc") String loc) throws IOException, ParseException, org.json.simple.parser.ParseException {
        return WeatherUtil.getWeather(loc, wkey);
    }
    @RequestMapping("/savedata")
    public Object savedata(@RequestParam("logType") String logType, @RequestParam("logData") String logData) throws IOException {
        switch (logType) {
            case "log1":
                loggerService1.save1(logData);
                break;
            case "log2":
                loggerService2.save2(logData);
                break;
            case "log3":
                loggerService3.save3(logData);
                break;
            case "log4":
                loggerService4.save4(logData);
                break;
        }
        return "OK";
    }
    @RequestMapping("/saveaudio")
    public Object saveaudio(@RequestParam("file") MultipartFile file) throws IOException {
        FileUploadUtil.saveFile(file, "C:/smspring/audios/");
        return "OK";
    }
    @RequestMapping("/saveimg")
    public Object saveimg(@RequestParam("file") MultipartFile file) throws IOException {
        FileUploadUtil.saveFile(file, "C:/smspring/imgs/");
        return "OK";
    }
}