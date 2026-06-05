extends Node

const ENCRYPTION_KEY: String = "dhfjklash#uniers*jnbvcjk";

func aes_encrypt_string(input_str: String) -> String:
	var aes = AESContext.new();
	var data = input_str.to_utf8_buffer();
	
	# Data must be a multiple of 16 bytes for AES
	while data.size() % 16 != 0:
		data.append(0);
	
	# Key must be 16, 24, or 32 characters long
	aes.start(AESContext.MODE_ECB_ENCRYPT, ENCRYPTION_KEY.to_utf8_buffer());
	var encrypted = aes.update(data);
	aes.finish();
	return encrypted.get_string_from_utf8();

func aes_decrypt_string(encrypted_data: String) -> String:
	var aes = AESContext.new();
	aes.start(AESContext.MODE_ECB_DECRYPT, ENCRYPTION_KEY.to_utf8_buffer());
	var decrypted = aes.update(encrypted_data.to_utf8_buffer());
	aes.finish();
	return decrypted.get_string_from_utf8().strip_edges();
