package com.muhibsoft.matounso;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.security.crypto.password.PasswordEncoder;

@SpringBootApplication
public class MatounsoApplication implements CommandLineRunner {

	public static void main(String[] args) {
		SpringApplication.run(MatounsoApplication.class, args);
	}

	@Autowired
	PasswordEncoder passwordEncoder;

	@Override
	public void run(String... args) {
		String mot = passwordEncoder.encode("Laddis001$");
		System.out.println("mot de passe est " + mot);
	}
}