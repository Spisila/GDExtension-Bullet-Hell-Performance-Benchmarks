# Title : GDExtension-Bullet-Hell-Performance-Benchmarks

## Project Goal: A high-performance C++ GDExtension for handling thousands of bullets in Godot 4.5

## Build Instructions: 
1. git clone --recursive [URL]
2. cd extension_src
3. scons platform=windows -j8

Current Status: "Phase 1: Project Architecture & GDExtension Bridge (Complete)."


# GDExtension Bullet Hell Performance Benchmarks

> **A high-performance C++ GDExtension for handling thousands of bullets in Godot 4.5.**

---

## The Problem & Solution

This project is a comparative study of different implementation strategies for bullet hell games in Godot 4.5, ranging from only using GDScript to multithreaded C++ GDExtensions.

