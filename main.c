#include <assert.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <readline/readline.h>

#define EQLFLT(x, y) (((x) - (y)) < 0.00001)

int
is_valid_coin(double coin)
{
  return EQLFLT(coin, 0.05) | EQLFLT(coin, 0.10) | EQLFLT(coin, 0.25) | EQLFLT(coin, 0.5);
}

float
ask_for_balance()
{
  double coin;
  double saldo = 0;

  char* line;
  while ((line = readline("Ingrese monedas: ")) != NULL)
    {
      coin = atof(line);

      if (coin == -1.0)
        {
          free(line);
          break;
        }

      if (!is_valid_coin(coin))
        {
          fprintf(stderr, "Moneda incorrecta\n");
        }
      else
        {
          saldo += coin;
        }

      free(line);
    }

  return saldo;
}

int
is_valid_phone_number(char* number)
{
  if (strlen(number) != 10)
    return 0;

  while (*number)
    {
      /*
        !(A && B) == !A || !B
        !(A >= B) == A < B
       */
      if (!(*number >= '0' && *number <= '9'))
        return 0;
      number++;
    }

  return 1;
}

void
ask_for_phone_number()
{
  char* line;

  while ((line = readline("Ingrese el numero a llamar: ")) != NULL)
    {
      if (is_valid_phone_number(line))
        {
          free(line);
          return;
        }

      fprintf(stderr, "Numero incorrecto\n");
      free(line);
    }
}

int
simulate_call()
{
  int minutes = 0;
  char* ans = readline("Iniciar la llamada? ");

  if (strcmp(ans, "Si") != 0)
    return minutes;

  free(ans);

  while (1)
    {
      minutes += 1;
      printf("%d. Llamada en curso ... Presiona C para colgar\n", minutes);

      int c = getchar();
      if (c == 'c' || c == 'C')
        break;
    }

  return minutes;
}

int
run()
{

  float saldo = ask_for_balance();
  printf("Su saldo es %.2f\n", saldo);
  printf("\n");

  int price_per_minute = (rand() + 10) % 40;
  printf("Costo de la llamada: $ 0.%d\n", price_per_minute);

  ask_for_phone_number();
  int minutes = simulate_call();

  float final_price = (price_per_minute / 100.0) * minutes;
  printf("Costo de la llamada: $ %.2f\n", final_price);
  // TODO: Duracion de la llamada

  printf("Cambio: $ %.2f\n", saldo - final_price);

  return 0;
}

int
main()
{
  srand(time(NULL));
  return run();
}
