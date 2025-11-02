package com.muhibsoft.matounso;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@SpringBootTest
class MatounsoApplicationTests {

	@Test
	void contextLoads() {
		String rawPassword = "admin123"; // mot de passe en clair
		String encodedPassword = new BCryptPasswordEncoder().encode(rawPassword);
		System.out.println(encodedPassword);
	}

}
