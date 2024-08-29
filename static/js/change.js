
                                    var checkGlobal;
                                    $(document).ready(function () {

                                        $("input").prop('disabled', true);
                                        $("textarea").prop('disabled', true);
                                        $("select").prop('disabled', true);
                                        $("checkbox").prop('disabled', true);
                                        $("radio").prop('disabled', true);
                                        $("#nDocumento").prop('disabled', false);
                                        $('#nDocumento').keyup(function () {
                                            str = $(this).val();

                                            testAjax(str);


                                        });


                                    });


                                    function testAjax(cedula) {

                                        $.ajax({
                                            url: 'validarCedula.php?id=' + cedula + '',
                                            type: 'GET',
                                            dataType: "json",
                                            success: function (data) {


                                                if (data[0] >= 1 && data[0] != '' ) {
                                                    $("input").prop('disabled', true);
                                                    $("textarea").prop('disabled', true);
                                                    $("select").prop('disabled', true);
                                                    $("checkbox").prop('disabled', true);
                                                    $("radio").prop('disabled', true);
                                                    $("#nDocumento").prop('disabled', false);
                                                    $('#msgCedula').text('La cedula existe');

                                                } else {
                                                    validarCedula();
                                                    $('#msgCedula').text('La cedula no existe');
                                                }


                                            },
                                            error: function (jqXHR, textStatus, error) {

                                                alert("error: " + jqXHR.responseText);
                                            }
                                        });
                                    }





                                    function validarCedula() {

                                        $("#txtDocumento").text(str);
                                        $("input").prop('disabled', false);
                                        $("textarea").prop('disabled', false);
                                        $("select").prop('disabled', false);
                                        $("checkbox").prop('disabled', false);
                                        $("radio").prop('disabled', false);
                                        $("#nDocumento").prop('disabled', false);

                                        // $('#nOficio').keyup(function () {
                                        //     txtOficio = $('#nOficio').val();
                                        //     $("#txtOficio").text(txtOficio);
                                        // });


                                        $('#nombreCompleto').keyup(function () {
                                            txtNombre = $('#nombreCompleto').val();
                                            $("#txtNombre").text(txtNombre);
                                        });

                                        $("#lTramite").change(function () {
                                            var str = "";

                                            $("#lTramite option:selected").each(function () {
                                                str += $(this).text() + " ";
                                            });


                                            $('#txtTramite').text(str);
                                        }).change();

                                        $("#motivoAutorizacion").change(function () {
                                            var str = "";
                                            $("#motivoAutorizacion option:selected").each(function () {
                                                str += $(this).text() + " ";
                                            });
                                            $('#txtMotivo').text(str);
                                        }).change();

                                        $("#tipoDocumento").change(function () {
                                            var str = "";
                                            $("#tipoDocumento option:selected").each(function () {
                                                str += $(this).text() + " ";
                                                valor = $(this).val();
                                                switch( valor ) {
                                                    case '2': // CC
                                                        consignacion = 49350;
                                                        break;
                                                    case '3': // TI
                                                        consignacion = 48400;
                                                        break;
                                                    case '1': // RC
                                                        consignacion = 8000;
                                                        break;
                                                    case '4':
                                                        consignacion = 4500;
                                                        break;
                                                    default:
                                                        consignacion = 0;
                                                        break;
                                                }
                                            });
                                            $('#txtTipoDocumento').text(str);
                                            $('#valorConsignacion').val(consignacion);
                                        }).change();

                                        $("#banco").change(function () {
                                            var str = "";
                                            var particula = "";
                                            $("#banco option:selected").each(function () {
                                                str += $(this).text() + " ";
                                                valor = $(this).val();
                                                if ( valor == 1 || valor == 2 ) {
                                                    particula += "del" + " ";
                                                }
                                                else {
                                                    particula += "de" + " ";
                                                }
                                            });
                                            $('#particulaBanco').text(particula);
                                            $('#txtBanco').text(str);
                                        }).change();

                                        $('#aPlano').keyup(function () {
                                            txtPlano = $('#aPlano').val();
                                            $("#txtPlano").text(txtPlano);
                                        });

                                        //Checkboxes
                                        $("#checkboxes").change(function () {
                                            var favorite = [];
                                            $.each($("input[name='vDoc']:checked"), function () {

                                                favorite.push($(this).val());
                                                $("#txtValidacion").text(favorite.join(", "));

                                            });
                                            checkGlobal = favorite;
                                        });


                                        $("#madeBy").change(function () {
                                            //var str = "";
                                            $("#madeBy option:selected").each(function () {
                                                //str += $(this).text();
                                                valor = $(this).val();
                                    
                                                if ( valor == "" || valor == null || valor == 0 ) {
                                                    $('#madeBy').css( 'border-color', 'red' );
                                                    $('#btnExportar').prop('disabled', true);
                                                    $('#btnGuardar').prop('disabled', true);
                                                }
                                                else {
                                                    $('#madeBy').css( 'border-color', '' );
                                                    $('#btnExportar').prop('disabled', false); 
                                                    nOfic = $('#nOficio').val();
                                                    if ( nOfic == '' || nOfic == 0 ) {
                                                        $('#btnGuardar').prop('disabled', false); 
                                                    }
                                                }
                                            });
                                            madeBy = str;
                                        }).change();




                                    }


                                    function guardar() {

                                        nDocumento = $('#nDocumento').val();
                                        nOficio = $('#nOficio').val();
                                        motivoAutorizacion = $('#motivoAutorizacion').val();
                                        aPlano = $('#aPlano').val();
                                        tipoDocumento = $('#tipoDocumento').val();
                                        nombreCompleto = $('#nombreCompleto').val();
                                        banco = $('#banco').val();
                                        dFecha = $('#dFecha').val();
                                        valorConsignacion = $('#valorConsignacion').val();
                                        lTramite = $('#lTramite').val();
                                        observacion = $('#observacion').val();
                                        ip = $("#ip").val();
                                        $.ajax({
                                            url: 'registroOficios.php?nDocumento=' + nDocumento + '&nOficio=' + nOficio + '&motivoAutorizacion='
                                                    + motivoAutorizacion + '&aPlano=' + aPlano + '&tipoDocumento=' + tipoDocumento +
                                                    '&nombreCompleto=' + nombreCompleto + '&banco=' + banco + '&dFecha=' + dFecha + '&valorConsignacion=' + valorConsignacion +
                                                    '&lTramite=' + lTramite + '&observacion=' + observacion + '&vDoc=' + checkGlobal + '&ip=' + ip + '',
                                            type: 'GET',
                                            dataType: "json",
                                            success: function (data) {


                                                texto = data;
                                                boton = $('<button type="button" class="btn btn-success" id="btnExportar" onclick="pdf();" >Exportar a PDF '+data.id+'</button>');
                                                boton.appendTo($("#botonPdf"));

                                                $("#txtOficio").text(data.nOficio);
                                                $("#nOficio").val(data.nOficio);
                                                $("#btnGuardar").prop("disabled", true);



                                            },
                                            error: function (jqXHR, textStatus, error) {

                                                alert("error: " + jqXHR.responseText);
                                            }
                                        });
                                    }


                                    function pdf() {

                                        nDocumento = $('#nDocumento').val();
                                        nOficio = $('#nOficio').val();

                                        $("#motivoAutorizacion").change(function () {
                                            var str = "";
                                            var strVal = "";
                                            $("#motivoAutorizacion option:selected").each(function () {
                                                str += $(this).text();
                                                strVal += $(this).val();
                                            });
                                            motivoAutorizacion = str;
                                            motivoAutorizacionVal = strVal;
                                        }).change();

                                        aPlano = $('#aPlano').val();

                                        $("#tipoDocumento").change(function () {
                                            var str = "";
                                            $("#tipoDocumento option:selected").each(function () {
                                                str += $(this).text() + " ";
                                            });
                                            tipoDocumento = str;
                                        }).change();


                                        nombreCompleto = $('#nombreCompleto').val();

                                        // $("#banco").change(function () {
                                        //     var str = "";
                                        //     $("#banco option:selected").each(function () {
                                        //         str += $(this).text() + " ";
                                        //     });
                                        //     banco = str;
                                        // }).change();


                                        $("#banco").change(function () {
                                            var str = "";
                                            var particula = "";
                                            $("#banco option:selected").each(function () {
                                                str += $(this).text() + " ";
                                                valor = $(this).val();
                                                if ( valor == 1 || valor == 2 ) {
                                                    particula += "del" + " ";
                                                }
                                                else {
                                                    particula += "de" + " ";
                                                }
                                            });
                                            banco = particula + str;
                                        }).change();


                                        dFecha = $('#dFecha').val();
                                        valorConsignacion = $('#valorConsignacion').val();

                                        $("#lTramite").change(function () {
                                            var str = "";
                                            $("#lTramite option:selected").each(function () {
                                                str += $(this).text() + " ";
                                            });
                                            lTramite = str;
                                        }).change();

                                        observacion = $('#observacion').val();


                                        ip = $("#ip").val();
//                                        $("#observacion").text(checkGlobal.join(", "));

                                        $("#madeBy").change(function () {
                                            var str = "";
                                            $("#madeBy option:selected").each(function () {
                                                str += $(this).text();
                                            });
                                            madeBy = str;
                                        }).change();

                                        window.open('pdf.php?nDocumento=' + nDocumento + '&nOficio=' + nOficio + '&motivoAutorizacion='
                                                + motivoAutorizacion + '&motivoAutorizacionVal=' + motivoAutorizacionVal + '&aPlano=' + aPlano + '&tipoDocumento=' + tipoDocumento +
                                                '&nombreCompleto=' + nombreCompleto + '&banco=' + banco + '&dFecha=' + dFecha + '&valorConsignacion=' + valorConsignacion +
                                                '&lTramite=' + lTramite + '&observacion=' + observacion + '&vDoc=' + checkGlobal + '&ip=' + ip + '&madeBy=' + madeBy + '', '_blank');





                                    }

                                    function isNumeric (evt) {
                                        var theEvent = evt || window.event;
                                        var key = theEvent.keyCode || theEvent.which;
                                        key = String.fromCharCode (key);
                                        var regex = /[0-9]/;
                                        if ( !regex.test(key) ) {
                                            theEvent.returnValue = false;
                                            if(theEvent.preventDefault) theEvent.preventDefault();
                                        }
                                    }

