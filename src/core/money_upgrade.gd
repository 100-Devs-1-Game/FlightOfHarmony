class_name MoneyUpgrade
extends ShopUpgrade


@export var bonus: int= 0



func get_display_name()-> String:
	return display_name + "\n(+%d percent earned)" % bonus
