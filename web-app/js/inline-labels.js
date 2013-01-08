$(document).ready(function() {
    $('#password-clear').show();
    $('#password').hide();

    $('#password-clear').focus(function() {
        $('#password-clear').hide();
        $('#password').show();
        $('#password').focus();
    });
    $('#password').blur(function() {
        if($('#password').val() == '') {
            $('#password-clear').show();
            $('#password').hide();
        }
    });

    $('#password-clear2').show();
    $('#password2').hide();

    $('#password-clear2').focus(function() {
        $('#password-clear2').hide();
        $('#password2').show();
        $('#password2').focus();
    });
    $('#password2').blur(function() {
        if($('#password2').val() == '') {
            $('#password-clear2').show();
            $('#password2').hide();
        }
    });

    $('.default-value').each(function() {
        var default_value = this.value;
        $(this).focus(function() {
            if(this.value == default_value) {
                this.value = '';
            }
        });
        $(this).blur(function() {
            if(this.value == '') {
                this.value = default_value;
            }
        });
    });

});