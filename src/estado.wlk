class Estado {

    method puedeHacerTurno() {
        return false
    }

}


object estatico inherits Estado {

    override method puedeHacerTurno() {
        return true
    }

}


object curandose inherits Estado { }
object combatiendo inherits Estado { }
object muriendo inherits Estado { }