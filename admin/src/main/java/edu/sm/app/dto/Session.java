package edu.sm.app.dto;
import lombok.*; import java.sql.Timestamp;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class Session {
    private Long sessionId;
    private Integer custId;
    private Integer adminId;
    private Integer cateId;
    private String  cateName;
    private String  status;
    private Timestamp requestedAt, startedAt, endedAt;
}

