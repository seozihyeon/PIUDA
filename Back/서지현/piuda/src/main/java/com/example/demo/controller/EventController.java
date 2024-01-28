package com.example.demo.controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import org.springframework.web.bind.annotation.*;

import com.example.demo.mapper.EventMapper;
import com.example.demo.model.Event;

import java.util.List;

@RestController
@RequestMapping("/api/events") 
public class EventController {

    private EventMapper mapper;
    
    public EventController(EventMapper mapper) {
    	this.mapper = mapper;
    }

    @GetMapping("/{event_library}")
    public List<Event> getEventsByLibrary(@PathVariable("event_library") String event_library) {
        return mapper.findEventsByLibrary(event_library);
    }
}
