import '../models/wine.dart';
import '../models/winery.dart';

// Тестовые данные (позже будут загружаться с вашего API)

final List<Wine> mockWines = [
  Wine(
    id: '1',
    name: 'Fetească Neagră Premium',
    wineryName: 'Château Vartely',
    type: 'red_dry',
    grapeVariety: 'Fetească Neagră',
    vintage: 2020,
    rating: 4.8,
    priceLei: 180,
    imageUrl: 'https://images.unsplash.com/photo-1586370434639-0fe43b2d32e6?q=80&w=600',
    description: 'Богатый аромат спелой вишни, чернослива и сафьяновой кожи.',
  ),
  Wine(
    id: '2',
    name: 'Viorica de Purcari',
    wineryName: 'Château Purcari',
    type: 'white_dry',
    grapeVariety: 'Viorica',
    vintage: 2023,
    rating: 4.9,
    priceLei: 145,
    imageUrl:
        'https://images.unsplash.com/photo-1558001373-7b93ee48ffa0?q=80&w=600',
    description: 'Свежий вкус с нотами муската, цитрусовых и белых цветов.',
  ),
  Wine(
    id: '3',
    name: 'Rară Neagră Taraboste',
    wineryName: 'Château Vartely',
    type: 'red_dry',
    grapeVariety: 'Rară Neagră',
    vintage: 2019,
    rating: 4.7,
    priceLei: 320,
    imageUrl: 'https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?q=80&w=600',
    description: 'Выдержанное вино с оттенками сухофруктов и дуба.',
  ),
  Wine(
    id: '4',
    name: 'Cricova Brut',
    wineryName: 'Cricova',
    type: 'sparkling',
    grapeVariety: 'Chardonnay, Pinot Noir',
    vintage: 2021,
    rating: 4.6,
    priceLei: 210,
    imageUrl:
        'https://images.unsplash.com/photo-1558001373-7b93ee48ffa0?q=80&w=600',
    description:
        'Классическое игристое с тонкой перлажью, нотами яблока и бриоши.',
  ),
  Wine(
    id: '5',
    name: 'Rosé de Mimi',
    wineryName: 'Castel Mimi',
    type: 'rose_dry',
    grapeVariety: 'Pinot Noir',
    vintage: 2023,
    rating: 4.5,
    priceLei: 190,
    imageUrl:
        'https://images.unsplash.com/photo-1558001373-7b93ee48ffa0?q=80&w=600',
    description: 'Лёгкое розовое с ароматом клубники, малины и цветов.',
  ),
  Wine(
    id: '6',
    name: 'Asconi Sauvignon Blanc',
    wineryName: 'Asconi',
    type: 'white_dry',
    grapeVariety: 'Sauvignon Blanc',
    vintage: 2023,
    rating: 4.4,
    priceLei: 130,
    imageUrl:
        'https://images.unsplash.com/photo-1558001373-7b93ee48ffa0?q=80&w=600',
    description: 'Хрустящее белое с нотами крыжовника, лайма и свежей травы.',
  ),
  Wine(
    id: '7',
    name: 'Et Cetera Merlot',
    wineryName: 'Et Cetera',
    type: 'red_dry',
    grapeVariety: 'Merlot',
    vintage: 2020,
    rating: 4.6,
    priceLei: 250,
    imageUrl: 'https://images.unsplash.com/photo-1586370434639-0fe43b2d32e6?q=80&w=600',
    description: 'Мягкое бархатистое красное со спелой сливой и шоколадом.',
  ),
  Wine(
    id: '8',
    name: 'Mileștii Mici Cabernet Sauvignon',
    wineryName: 'Mileștii Mici',
    type: 'red_dry',
    grapeVariety: 'Cabernet Sauvignon',
    vintage: 2018,
    rating: 4.7,
    priceLei: 280,
    imageUrl: 'https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?q=80&w=600',
    description:
        'Выдержанное в подвалах вино с тонами чёрной смородины и табака.',
  ),
];

// Координаты примерные — уточните перед релизом
const List<Winery> mockWineries = [
  Winery(
    id: 1,
    name: 'Château Vartely',
    latitude: 47.3833,
    longitude: 28.8167,
    region: 'Codru · Orhei',
  ),
  Winery(
    id: 2,
    name: 'Château Purcari',
    latitude: 46.5250,
    longitude: 29.8650,
    region: 'Ștefan Vodă · Purcari',
  ),
  Winery(
    id: 3,
    name: 'Cricova',
    latitude: 47.1386,
    longitude: 28.8620,
    region: 'Codru · Cricova',
  ),
  Winery(
    id: 4,
    name: 'Mileștii Mici',
    latitude: 46.9050,
    longitude: 28.8280,
    region: 'Codru · Ialoveni',
  ),
  Winery(
    id: 5,
    name: 'Castel Mimi',
    latitude: 46.8900,
    longitude: 29.3050,
    region: 'Codru · Bulboaca',
  ),
  Winery(
    id: 6,
    name: 'Asconi',
    latitude: 46.8250,
    longitude: 29.0900,
    region: 'Codru · Puhoi',
  ),
  Winery(
    id: 7,
    name: 'Et Cetera',
    latitude: 46.4230,
    longitude: 29.9300,
    region: 'Ștefan Vodă · Crocmaz',
  ),
];

/// Вина конкретной винодельни (связь пока по названию).
List<Wine> winesOf(Winery winery) =>
    mockWines.where((w) => w.wineryName == winery.name).toList();
