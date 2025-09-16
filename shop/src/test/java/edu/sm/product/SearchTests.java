package edu.sm.product;

import edu.sm.app.dto.Cust;
import edu.sm.app.dto.CustSearch;
import edu.sm.app.dto.Product;
import edu.sm.app.dto.ProductSearch;
import edu.sm.app.service.CustService;
import edu.sm.app.service.ProductService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

@SpringBootTest
@Slf4j
class SearchTests {

    @Autowired
    ProductService productService;

    @Test
    void contextLoads() throws Exception {
        List<Product> list = null;
        ProductSearch productSearch = ProductSearch.builder()
                .productName("상의")
                .minPrice(30000)
                .maxPrice(500000)
                .cateId("상의")
                .build();
        list = productService.searchProductList(productSearch);
        list.forEach((c)->{log.info(c.toString());});

    }

}