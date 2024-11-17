import randomizer.*
import paleta.*
import personaje.*
import mapa.*


class Arma {
    var property estaEquipada = false
    const property position = randomizer.posicionRandomDeArma()
    const nivel = 1.randomUpTo(3).round() 
    var durabilidad  

    method durabilidad() {
      return durabilidad
    }

    method serEquipada() {
      self.estaEquipada(true) 
    }

    // El pj colsiona con el arma y la mete en la bolsa()
    method colisiono(personaje){
        personaje.equiparArma(self)
    }

    method realizarActualizacionDeArmas() {
        if ( self.durabilidad() <= 15) {
            personaje.actualizarArmaActual()
            personaje.bolsa().remove(personaje.bolsa().head()) //se borra esta arma, que era la primera y la anterior actual
        } else {
            self.restarDurabilidad(15)
        }
    }

    method restarDurabilidad(cantidadRestada) {
        durabilidad -= cantidadRestada
    }

    //se implementan en cada una de las subclases de tipos de arma (ya que en todas varía)
    method danho()
    method image() 
    method imagenParaPersonaje()
    method emojiParaInfoCombate()
    method habilidadEspecial()

    // Para test
    method text(){ return "Dur: " + self.durabilidad().toString() + "\nLvl: " + nivel.toString()}
    method textColor() = paleta.gris()
}

class Espada inherits Arma {

    override method danho() {
        return 35 + nivel * 3
    }

    override method image() {
        return "espadaGris-32Bits.png"
    }

    override method imagenParaPersonaje() {
        return "ConEspada"
    }

    override method habilidadEspecial() { //de momento, no está siendo usada en el juego
        return self.danho() * 2 //golpe critico RASGUÑO MORTALLLLL
    }

    override method emojiParaInfoCombate() {
        return "🗡"
    }

}

class ArcoYFlecha inherits Arma {

    override method danho() {
        return 20 + nivel * 3
    }
        override method image() {
        return "arcoYFlecha-32Bits.png"
    }

    override method imagenParaPersonaje() {
        return "ConArcoYFlecha"
    }

    override method habilidadEspecial() { //de momento, no está siendo usada en el juego
        return //veneno
    }

    override method emojiParaInfoCombate() {
        return "🏹"
    }

}

class MartilloDeGuerra inherits Arma {

    override method danho() {
        return 80 + nivel * 3
    }

    override method image() {
        return "martilloDeGuerra-32Bits.png"
    }

    override method imagenParaPersonaje() {
        return "ConMartilloDeGuerra"
    }

    override method habilidadEspecial() { //de momento, no está siendo usada en el juego
        return //pierde turno enemigo
    }

    override method emojiParaInfoCombate() {
        return "🪓"
    }

}

object mano { //objeto especial

    method danho() {
        return 5
    }

    var property durabilidad = "Infinita"
    
    method realizarActualizacionDeArmas() { } //necesario para que funcione el polimorfismo (todas las armas deben entenderlo)

    method emojiParaInfoCombate() {
        return "🤜"
    }
}

//FÁBRICAS (su única función es devolverme en nuevo objeto de la subclase de Arma a la que están ligadas. nos permiten crear armas random)

object fabricaDeEspada {

    method agregarNuevaArma() {
        const arma = new Espada(durabilidad = 90.randomUpTo(120).round())
        game.addVisual(arma)
    }

}

object fabricaDeArcoYFlecha {

    method agregarNuevaArma() {
        const arma = new ArcoYFlecha(durabilidad = 120.randomUpTo(150).round())
        game.addVisual(arma)
    }

}

object fabricaDeMartilloDeGuerra {

    method agregarNuevaArma() {
        const arma = new MartilloDeGuerra(durabilidad = 60.randomUpTo(90).round())
        game.addVisual(arma)
    }

}
