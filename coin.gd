extends Control

func Coin() -> void:
	var coin := State.user_data.coin
	if State.is_end == true:
		$halfwhitebar/coin.text = str(coin)
		$AnimationPlayer.play("coin")
		await get_tree().create_timer(2.2).timeout
		coin = State.user_data.coin
		$halfwhitebar/coin.text = str(coin)
