@tool
extends Node

## TODO convert all state to use global state enum
enum GameStates {NONE = 0 , CALIBRATION = 1, MENU = 2, PLAY = 3}

var GameState: GameStates = GameStates.NONE
