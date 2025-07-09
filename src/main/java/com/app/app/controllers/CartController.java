package com.app.app.controllers;

import com.app.app.entity.Cart;
import com.app.app.entity.User;
import com.app.app.services.CartService;
import com.app.app.services.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/cart")
public class CartController {

    private static final Logger log = LoggerFactory.getLogger(CartController.class);
    private final CartService cartService;
    private final UserService userService;

    @Autowired
    public CartController(CartService cartService, UserService userService) {
        this.cartService = cartService;
        this.userService = userService;
    }

    @GetMapping
    public Cart getCart(@AuthenticationPrincipal Jwt jwt) {
        String username = jwt.getSubject();
        log.info("Fetching cart for user: {}", username);
        User user = userService.findByUsername(username);
        return cartService.getCartByUser(user);
    }

    @GetMapping("/count")
    public Map<String, Integer> getCartCount(@AuthenticationPrincipal Jwt jwt) {
        String username = jwt.getSubject();
        User user = userService.findByUsername(username);
        Cart cart = cartService.getCartByUser(user);
        int count = cart != null && cart.getItems() != null ? cart.getItems().size() : 0;
        
        Map<String, Integer> response = new HashMap<>();
        response.put("count", count);
        return response;
    }

    @PostMapping("/add")
    public void addToCart(@AuthenticationPrincipal Jwt jwt,
                          @RequestParam Long productId,
                          @RequestParam int quantity) {
        String username = jwt.getSubject();
        User user = userService.findByUsername(username);
        cartService.addProductToCart(user, productId, quantity);
    }

    @DeleteMapping("/remove")
    public void removeFromCart(@AuthenticationPrincipal Jwt jwt,
                               @RequestParam Long productId) {
        String username = jwt.getSubject();
        User user = userService.findByUsername(username);
        cartService.removeProductFromCart(user, productId);
    }
}
