package com.app.app.controllers;


import com.app.app.entity.Cart;
import com.app.app.entity.Product;
import com.app.app.entity.User;
import com.app.app.services.CartService;
import com.app.app.services.ProductService;
import com.app.app.services.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.ui.Model;


import java.util.List;

@Controller
public class ViewsController {
    private static final Logger log = LoggerFactory.getLogger(ViewsController.class);
    @Autowired
    private ProductService productService;
    @Autowired
    private CartService cartService;
    @Autowired
    private UserService userService;

    @GetMapping("/login")
    public String login() {


        return "login"; // /WEB-INF/jsp/login.jsp
    }
    @GetMapping("/register")
    public String register() {
        return "register"; // maps to /WEB-INF/jsp/register.jsp
    }

    @GetMapping("/products")
    public ModelAndView getProducts() {
        ModelAndView modelAndView = new ModelAndView("products");
        List<Product> products = productService.getAllProducts();
        modelAndView.addObject("products", products);
        // Removed user and cartCount logic (now handled client-side)
        return modelAndView;
    }

    @GetMapping("/cart")
    public String showCartPage(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication instanceof JwtAuthenticationToken jwtAuthToken) {
            Jwt jwt = jwtAuthToken.getToken();

            // Access JWT claims
            String username = jwt.getClaimAsString("sub");
            List<String> roles = jwt.getClaimAsStringList("roles");


            User user = userService.findByUsername(username);

            Cart cart = cartService.getCartByUser(user);
            int cartCount = cart.getItems().size();

            model.addAttribute("user", user);
            model.addAttribute("cart", cart);
            model.addAttribute("cartCount", cartCount);
            log.info("Cart for user {}: {}", username, cart);
            return "cart";
        }

        // fallback or error view if JWT is not present
        return "redirect:/login";
    }


}
