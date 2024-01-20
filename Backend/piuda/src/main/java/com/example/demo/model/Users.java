package com.example.demo.model;

public class Users {
	private Long user_id;
	private String user_name;
	private String user_status;
	private String barcode_img;
	
	public Users(Long user_id, String user_name, String user_status, String barcode_img) {
		super();
		this.user_id = user_id;
		this.user_name = user_name;
		this.user_status = user_status;
		this.barcode_img = barcode_img;
	}

	public Long getId() {
		return user_id;
	}

	public void setId(Long user_id) {
		this.user_id = user_id;
	}

	public String getName() {
		return user_name;
	}

	public void setName(String user_name) {
		this.user_name = user_name;
	}

	public String getStatus() {
		return user_status;
	}

	public void setStatus(String user_status) {
		this.user_status = user_status;
	}

	public String getBarcode() {
		return barcode_img;
	}

	public void setBarcode(String barcode_img) {
		this.barcode_img = barcode_img;
	}
}