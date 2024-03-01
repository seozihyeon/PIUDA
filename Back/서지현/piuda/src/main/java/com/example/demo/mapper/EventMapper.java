package com.example.demo.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.example.demo.model.Event;

import java.util.List;

@Mapper
public interface EventMapper {

    @Select("SELECT * FROM event WHERE event_library = #{event_library}")
    List<Event> findEventsByLibrary(@Param("event_library")String event_library);
}