package com.app.app.controllers;

import com.app.app.config.JwtUtil;
import com.app.app.dto.UserRegistrationDto;
import com.app.app.entity.User;
import com.app.app.services.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private static final Logger log = LoggerFactory.getLogger(AuthController.class);
    private final UserService userService;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    @Autowired
    public AuthController(UserService userService, PasswordEncoder passwordEncoder, JwtUtil jwtUtil) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
        this.jwtUtil = jwtUtil;
    }

    @PostMapping("/register")
    public String registerUser(@RequestBody UserRegistrationDto registrationDto) {
        User user = new User();
        user.setUsername(registrationDto.getUsername());
        user.setPassword(registrationDto.getPassword());
        user.setEmail(registrationDto.getEmail());
        user.setName(registrationDto.getName());
        userService.registerUser(user);
        return "User registered successfully";
    }



    @PostMapping("/login")
    public String loginUser(@RequestBody UserRegistrationDto loginDto) {
        log.info("Login attempt for user: {}", loginDto.getUsername());
        User user = userService.findByUsername(loginDto.getUsername());
        if (user == null) {
            return "Invalid username or password";
        }

        if (passwordEncoder.matches(loginDto.getPassword(), user.getPassword())) {
            log.info("Success: {}", loginDto.getUsername());
            return  jwtUtil.generateToken(user.getUsername(), user.getRole());

        } else {
            return "Invalid username or password";
        }
    }



    }

