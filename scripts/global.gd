extends Node

var on_cutscene = false #sert à bloquer les mouvements du héro lorsqu'il est en cutscene

var player = {
	"stat" : [1,12,13,20],
	"name" : "LaKhlef",
	"class" : 1,
	"skin" : {
		"body" : {
			"gender" : "male",
			"color" : Color(0.976, 0.757, 0.616, 1.0),
		},
		"eyes" : {
			"color" : Color(0.0, 0.51, 1.0, 1.0),
		},
		"clothing" : {
			"sprite" : 1,
		},
		"hair" : {
			"front" : 0,
			"rear" : 0,
			"color" : Color(1.0, 0.85, 0.4, 1.0),
		},
		"accessory" : {
			"sprite" : 0,
		}
	}
}

var classes = {
	1 : {
		"name" : "Guerrier",
		"description" : "Les guerriers sont des combattants aguerris qui excellent dans le combat rapproché. Leur force brute et leur endurance leur permettent de résister aux pires blessures tout en infligeant des dégâts considérables. Armés d’épées, de haches ou de marteaux de guerre, ils se battent avec une intensité féroce, écrasant leurs adversaires sous des coups dévastateurs. Leur entraînement rigoureux leur confère une résistance exceptionnelle, leur permettant de rester debout même après des affrontements prolongés."
		},
	2 : {
		"name" : "Enchanteur",
		"description" : "Les enchanteurs sont des guérisseurs et des protecteurs, maîtrisant la magie de la lumière pour soigner et renforcer leurs alliés. Grâce à leur pouvoir, ils peuvent non seulement réparer les blessures physiques, mais aussi créer des boucliers mystiques pour protéger ceux qui les entourent. Leur maîtrise des énergies mystiques leur permet d'enchanter armes et armures, rendant leurs alliés plus puissants tout en affaiblissant les ennemis avec des sorts de lumière."
		},
	3 : {
		"name" : "Chevalier"
	}
}
