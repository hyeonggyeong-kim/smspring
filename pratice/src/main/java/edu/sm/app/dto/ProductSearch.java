package edu.sm.app.dto;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class ProductSearch {
    String productName;
    Integer minPrice;
    Integer maxPrice;
    String cateId;
}