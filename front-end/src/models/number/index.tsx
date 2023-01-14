export const formatNumber = (number: number) =>
  new Intl.NumberFormat("es-ES", { maximumFractionDigits: 2 }).format(number);
