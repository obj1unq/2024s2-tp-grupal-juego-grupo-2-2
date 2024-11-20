import randomizer.*
import paleta.*
import personaje.*
import mapa.*
import pelea.*
import enemigos.*


class Arma {
    const property position = randomizer.posicionRandomDeArma()
    const nivel = 1.randomUpTo(3).round() 
    var durabilidad  
    const portador = personaje

    method objetivo() {
        return portador.enemigoCombatiendo()
    }

    method durabilidad() {
      return durabilidad
    }

    // El pj colsiona con el arma y la mete en la bolsa()
    method colisiono(personaje){
        personaje.equiparArma(self)
        game.removeVisual(self)
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
    method imagenHabilidadEspecialParaBarra()

    method ejecutarHabilidadEspecial() {
        portador.gastarFuerzaAcumulada()
        self.sonidoDelArmaEspecial()
    }
    method sonidoDelArma()
    method sonidoDelArmaEspecial()


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

    override method emojiParaInfoCombate() {
        return "🗡 (espada)"
    }

    override method ejecutarHabilidadEspecial() { //ATURDIMIENTO
        super()
        self.objetivo().recibirDanho(self.danho()) 
        self.objetivo().estaAturdido(true)
       
    }

    override method imagenHabilidadEspecialParaBarra() {
        return "Aturdimiento"
    }

    override method sonidoDelArma() {
       game.sound("espada.mp3").play()
    }
    
    override method sonidoDelArmaEspecial() {
       game.sound("aturdido.mp3").play()
    }
}

class Lanza inherits Arma {

    override method danho() {
        return 20 + nivel * 3
    }
        override method image() {
        return "arcoYFlecha-32Bits.png"
    }

    override method imagenParaPersonaje() {
        return "ConLanza"
    }

    override method emojiParaInfoCombate() {
        return "𐃆 (lanza)"
    }

    override method ejecutarHabilidadEspecial() { //EMBESTIDA
        super()
        self.objetivo().recibirDanho(self.danho()*3) 
       
    }

    override method imagenHabilidadEspecialParaBarra() {
        return "Embestida"
    }

    override method sonidoDelArma() {
       game.sound("lanza.mp3").play()
    }

    override method sonidoDelArmaEspecial() {
        game.sound("embestida.mp3").play()
    }
}

class Maza inherits Arma {

    override method danho() {
        return 80 + nivel * 3
    }

    override method image() {
        return "martilloDeGuerra-32Bits.png"
    }

    override method imagenParaPersonaje() {
        return "ConMaza"
    }

    override method emojiParaInfoCombate() {
        return "🪓 (maza)"
    }

    override method ejecutarHabilidadEspecial() { //ENVENENAMIENTO
        super()
        self.objetivo().recibirDanho(self.danho()) 
        self.objetivo().cantidadDeVeneno(3)
    }

    override method imagenHabilidadEspecialParaBarra() {
        return "Envenenamiento"
    }

    override method sonidoDelArma() {
       game.sound("hacha.mp3").play()
    }

    override method sonidoDelArmaEspecial() {
        game.sound("envenenamiento.mp3").play()
    }

}

object mano { //objeto especial
    const portador = personaje

    method objetivo() {
        return portador.enemigoCombatiendo()
    }

    method danho() {
        return 5
    }

    var property durabilidad = "Infinita"
    
    method realizarActualizacionDeArmas() { } //necesario para que funcione el polimorfismo (todas las armas deben entenderlo)

    method imagenParaPersonaje() {
        return ""
    }

    method emojiParaInfoCombate() {
        return "🤜 (mano)"
    }

    method ejecutarHabilidadEspecial() { //PUÑETAZO
        portador.gastarFuerzaAcumulada()
        self.objetivo().recibirDanho(self.danho()*7) //35 de daño
        game.sound("puñetazoH.mp3").play()
    }

    method imagenHabilidadEspecialParaBarra() {
        return "Puñetazo"
    }

    method sonidoDelArma() {
       game.sound("puñetazo.mp3").play()
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
        const arma = new Lanza(durabilidad = 120.randomUpTo(150).round())
        game.addVisual(arma)
    }

}

object fabricaDeMartilloDeGuerra {

    method agregarNuevaArma() {
        const arma = new Maza(durabilidad = 60.randomUpTo(90).round())
        game.addVisual(arma)
    }

}
