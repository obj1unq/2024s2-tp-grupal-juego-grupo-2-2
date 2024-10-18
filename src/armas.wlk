import randomizer.*
import paleta.*
import personaje.*


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
    method habilidadEspecial()
    

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

    // Para test
    method text(){ return "Durabilidad: " + self.durabilidad().toString() + "\nNivel: " + nivel.toString()}
    method textColor() = paleta.azul()


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

    // Para test
    method text(){ return "Durabilidad: " + self.durabilidad().toString() + "\nNivel: " + nivel.toString()}
    method textColor() = paleta.azul()

    override method habilidadEspecial() { //de momento, no está siendo usada en el juego
        return //veneno
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

    // Para test
    method text(){ return "Durabilidad: " + self.durabilidad().toString() + "\nNivel: " + nivel.toString()}
    method textColor() = paleta.azul()

    override method habilidadEspecial() { //de momento, no está siendo usada en el juego
        return //pierde turno enemigo
    }

}

object mano { //objeto especial

    method danho() {
        return 5
    }

    var property durabilidad = "Infinita"
    
    method realizarActualizacionDeArmas() { } //necesario para que funcione el polimorfismo (todas las armas deben entenderlo)
}

//FÁBRICAS (su única función es devolverme en nuevo objeto de la subclase de Arma a la que están ligadas. nos permiten crear armas random)

object fabricaDeEspada {

    method nuevaArma() {
        return new Espada(durabilidad = 90.randomUpTo(120).round())
    }

}

object fabricaDeArcoYFlecha {

    method nuevaArma() {
        return new ArcoYFlecha(durabilidad = 120.randomUpTo(150).round())
    }

}

object fabricaDeMartilloDeGuerra {

    method nuevaArma() {
        return new MartilloDeGuerra(durabilidad = 60.randomUpTo(90).round())
    }

}
