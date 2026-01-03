extends Node2D

class_name Unit

func set_data(card: CardData):
	if $Artwork.texture is AtlasTexture:
		$Artwork.texture.atlas = card.art
	else:
		$Artwork.texture = card.art
	#$Attack.text = str(card.attack)
	#$Health.text = str(card.health)

func set_width(width: int):
	pass
