package edu.sm.app.dto;

import lombok.Data;

@Data           // ✅ 게터/세터/생성자/toString 자동
public class Marker {
    private int target;
    private String title;
    private String img;
    private double lat;
    private double lng;
    private String loc;
    private String info;
    private double distance;
}
