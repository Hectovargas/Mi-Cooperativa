
package mi_cooperativa_hv;


public class Afiliados_obj {
    private String codigo;
    private String primerNombre;
    private String primerApellido;

    // Constructor, getters y setters
    public Afiliados_obj(String codigo, String primerNombre, String primerApellido) {
        this.codigo = codigo;
        this.primerNombre = primerNombre;
        this.primerApellido = primerApellido;
    }

    @Override
    public String toString() {
        return codigo +" - "+primerNombre + " " + primerApellido; 
    }


    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getPrimerNombre() {
        return primerNombre;
    }

    public void setPrimerNombre(String primerNombre) {
        this.primerNombre = primerNombre;
    }

    public String getPrimerApellido() {
        return primerApellido;
    }

    public void setPrimerApellido(String primerApellido) {
        this.primerApellido = primerApellido;
    }
}  

