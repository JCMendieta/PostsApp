//
//  PostDetailsViewModel.swift
//  PostsApp
//
//  Created by Juan Camilo Mendieta Hernández on 24/04/25.
//

import Foundation

protocol PostDetailsViewModelProtocol {
    var coordinator: CoordinatorProtocol { get }
    var useCase: FetchPostDetailsUseCaseProtocol { get }
    var model: PostDetailsScreenModel { get set }
    
    func fetchPostDetails(postId: String, userId: String) async
    func mapToPostModel(from postDTO: PostDTO) -> Post
    func mapToUserModel(from userDTO: UserDTO) -> User
    func mapToCommentsModel(from commentsDTO: [CommentDTO]) -> [Comment]
}

final class PostDetailsViewModel: PostDetailsViewModelProtocol {
    var coordinator: any CoordinatorProtocol
    var useCase: any FetchPostDetailsUseCaseProtocol
    var model = PostDetailsScreenModel()
    
    init(
        coordinator: CoordinatorProtocol,
        useCase: any FetchPostDetailsUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.useCase = useCase
    }
    
    
    func fetchPostDetails(postId: String, userId: String) async {
        do {
            let postData = try await useCase.fetchPostDetails(postId: postId)
            model.post = mapToPostModel(from: postData)
            
            let userData = try await useCase.fetchUser(userId: userId)
            model.user = mapToUserModel(from: userData)
            
            let commentsData = try await useCase.fetchPostComments(postId: postId)
            model.comments = mapToCommentsModel(from: commentsData)
            
        } catch {
            print(error)
        }
    }
    
    func mapToPostModel(from postDTO: PostDTO) -> Post {
        return Post(from: postDTO)
    }
    
    func mapToUserModel(from userDTO: UserDTO) -> User {
        return User(from: userDTO)
    }
    
    func mapToCommentsModel(from commentsDTO: [CommentDTO]) -> [Comment] {
        let comments = commentsDTO.map { Comment(from: $0) }
        return comments
    }
}
