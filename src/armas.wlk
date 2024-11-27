import randomizer.*
import paleta.*
import personaje.*
import mapa.*
import pelea.*
import enemigos.*

class Arma {
      
    const portador = personaje
    var property durabilidad

    method objetivo() {
        return portador.enemigoCombatiendo()
    }

    method danho()
    method imagenParaPersonaje()
    method emojiParaInfoCombate
    method imagenHabilidadEspecialParaBarra()
    method realizarActualizacionDeArmas()
    method sonidoDelArma()
    method sonidoDelArmaEspecial()
    
    method ejecutarHabilidadEspecial() {
        portador.gastarFuerzaAcumulada()
    }

}

class ArmaEncontrable inherits Arma {
    var property position
    var nivel = 1.randomUpTo(3).round() //se cambia a variable para poder realizar los test

    method nivel(_nivel) { // solo se utiliza para los test
        nivel = _nivel
    }

    method image()

    method colisiono(personaje){
        personaje.equiparArma(self)  
        game.removeVisual(self)
    }

    override method realizarActualizacionDeArmas() {
        if ( self.durabilidad() <= 15) {
            personaje.descartarArmaActual() //se borra esta arma de la bolsa, que era la anterior actual
        } else {
            self.restarDurabilidad(15)
        }
    }

    method restarDurabilidad(cantidadRestada) {
        durabilidad -= cantidadRestada
        if(durabilidad <= 0){
            game.removeVisual(self)
        }
    }
}

class Espada inherits ArmaEncontrable {

    override method danho() {
        return 35 + nivel * 6
    }

    override method image() {
        return "espadaNivel" + nivel.toString() + ".png"
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
        self.objetivo().turnosAturdido(1)
    }

    override method imagenHabilidadEspecialParaBarra() {
        return "Aturdimiento"
    }

    override method sonidoDelArma() {
       game.sound("espada.mp3").play()
    }
    
    override method sonidoDelArmaEspecial() {
       game.sound("aturdimiento.mp3").play()
    }

}

class Lanza inherits ArmaEncontrable {

    override method danho() {
        return 25 + nivel * 6
    }
        override method image() {
        return "lanzaNivel" + nivel.toString() + ".png"
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

class Maza inherits ArmaEncontrable {

    override method danho() {
        return 60 + nivel * 6
    }

    override method image() {
        return "mazaCombateNivel" + nivel.toString() + ".png"
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
        self.objetivo().turnosEnvenenado(3)
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

//objeto especial que representa al arma por default
 //Su atributo durabilidad solo se usa para el string en la info del combate. NUNCA se hacen cálculos con este
//dato como si se hace con el atributo durabilidad de las instancias de las subclases de ArmaEncontrable.
object mano inherits Arma(durabilidad = "Infinita") {

    override method danho() { 
        return 5
    }
    
    override method imagenParaPersonaje() { 
        return ""
    }

    override method emojiParaInfoCombate() { 
        return "🤜 (mano)"
    }

    override method imagenHabilidadEspecialParaBarra() { 
        return "Puñetazo"
    }

    override method realizarActualizacionDeArmas() { } //necesario para que funcione el polimorfismo (todas las armas deben entenderlo) 

    override method ejecutarHabilidadEspecial() { //PUÑETAZO 
        super()
        self.objetivo().recibirDanho(self.danho()*7) //35 de daño
    }

    override method sonidoDelArma() {
       game.sound("puñetazo.mp3").play()
    }

    override method sonidoDelArmaEspecial() {
      game.sound("puñetazoH.mp3").play()
    }
    
}

//FÁBRICAS (su única función es devolverme en nuevo objeto de la subclase de Arma a la que están ligadas. nos permiten crear armas random)

object fabricaDeEspada {

    method agregarNuevaArma(_position) {
        const arma = new Espada(position = _position, durabilidad = 90.randomUpTo(120).round())
        game.addVisual(arma)
    }

}

object fabricaDeArcoYFlecha {

    method agregarNuevaArma(_position) {
        const arma = new Lanza(position = _position, durabilidad = 120.randomUpTo(150).round())
        game.addVisual(arma)
    }

}

object fabricaDeMartilloDeGuerra {

    method agregarNuevaArma(_position) {
        const arma = new Maza(position = _position, durabilidad = 60.randomUpTo(90).round())
        game.addVisual(arma)
    }

}
