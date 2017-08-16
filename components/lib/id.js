// Unique id generator

const digits = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

function toSex(num, base) {
  if (base) {
    num = parseInt(num, base);
  }
  let [integer, decimal] = num.toString().split('.');

  integer = parseInt(integer, 10);
  const sex = [];
  do {
    sex.push(digits[integer % 60]);
    integer = Math.floor(integer / 60);
  } while (integer > 0);

  let result = sex.reverse().join('');

  if (decimal) {
    decimal = parseFloat(`.${decimal}`);
    const rem = [];
    let precision = 4;
    do {
      decimal *= 60;
      const x = Math.floor(decimal);
      rem.push(digits[x]);
      decimal -= x;
      precision--;
    } while (precision);

    result += `.${rem.join('')}`;
  }

  return result;
}

function toDigits(str, n) {
  if (str.length === n) {
    return str;
  }

  if (str.length > n) {
    return str.substr(0, n);
  }

  do {
    str = `0${str}`;
  } while (str.length < n);

  return str;
}

let random = Math.floor(Math.random() * 60 * 60 * 60 * 60);

// export default function() {
//   const firstEightDigits = Math.random().toString(36).substr(2, 8);
//   const secondEightDigits = Math.random().toString(36).substr(2, 8);
//   return `${firstEightDigits}${secondEightDigits}`;
// }

export default function(idfv) {
  random++;
  const time = toSex(Math.floor(Date.now() / 1000));
  const device = idfv ? toSex(idfv.split('-')[4], 16) : '';
  return `${toDigits(time, 6)}${device && toDigits(device, 10)}${toDigits(
    toSex(random),
    4,
  )}`;
}
