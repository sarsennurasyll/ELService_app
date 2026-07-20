import { CategoryRepository } from '../repositories/category.repository';
import { AppError } from '../utils/app-error';

export class CategoryService {
  constructor(private readonly categoryRepository = new CategoryRepository()) {}

  async listCategories() {
    return this.categoryRepository.findAll();
  }

  async getCategoryById(id: string) {
    const category = await this.categoryRepository.findById(id);

    if (!category) {
      throw new AppError(404, 'Category not found', 'CATEGORY_NOT_FOUND');
    }

    return category;
  }
}
