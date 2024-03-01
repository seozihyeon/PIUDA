package com.example.demo.model;

import java.time.LocalDate;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;

@Entity
public class Event {
	@Id
    private int event_id;
	private String event_library;
	private String event_name;
	private LocalDate event_date;

    public int getEvent_id() {
        return event_id;
    }

    public void setEvent_id(int event_id) {
        this.event_id = event_id;
    }

   public String getEvent_library() {
	   return event_library;
   }
   
   public void setEvent_library(String event_library) {
	   this.event_library = event_library;
   }
   
   public String getEvent_name() {
	   return event_name;
   }
   
   public void setEvent_name(String event_name) {
	   this.event_name = event_name;
   }
   
   public LocalDate getEvent_date() {
	   return event_date;
   }
   
   public void setEvent_date(LocalDate event_date) {
	   this.event_date = event_date;
   }
}